#ifndef CLIPBOARDADAPTER_H
#define CLIPBOARDADAPTER_H

#include <QClipboard>

class ClipboardAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit ClipboardAdapter(QObject *parent = nullptr);
    Q_INVOKABLE void clear() { m_clipboard->clear(); }

signals:
    void textChanged();

private:
    QClipboard *m_clipboard;

private:
    inline QString text() { return m_clipboard->text(); }
    inline void setText(const QString &text) { m_clipboard->setText(text, QClipboard::Clipboard); }
};

#endif // CLIPBOARDADAPTER_H
