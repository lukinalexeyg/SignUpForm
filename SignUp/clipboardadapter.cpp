#include <QGuiApplication>
#include "clipboardadapter.h"



ClipboardAdapter::ClipboardAdapter(QObject *parent) :
    QObject(parent)
{
    m_clipboard = QGuiApplication::clipboard();
    connect(m_clipboard, &QClipboard::dataChanged, this, &ClipboardAdapter::textChanged);
}
