#include "clipboardadapter.h"

#include <QGuiApplication>



ClipboardAdapter::ClipboardAdapter(QObject *parent) :
    QObject(parent)
{
    m_clipboard = QGuiApplication::clipboard();
    connect(m_clipboard, &QClipboard::dataChanged, this, &ClipboardAdapter::textChanged);
}



void ClipboardAdapter::clear()
{
    m_clipboard->clear();
}



QString ClipboardAdapter::text() const
{
    return m_clipboard->text();
}



void ClipboardAdapter::setText(const QString &text)
{
    m_clipboard->setText(text, QClipboard::Clipboard);
}
