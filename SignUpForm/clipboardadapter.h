#ifndef CLIPBOARDADAPTER_H
#define CLIPBOARDADAPTER_H

#include <QClipboard>

class ClipboardAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit ClipboardAdapter(QObject *parent = nullptr);

    Q_INVOKABLE void clear();

signals:
    void textChanged();

private:
    QClipboard *m_clipboard;

private:
    QString text() const;
    void setText(const QString &text);
};

#endif // CLIPBOARDADAPTER_H
