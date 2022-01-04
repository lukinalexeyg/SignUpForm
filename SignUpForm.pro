TEMPLATE = subdirs

SUBDIRS += \
    SignUpForm \
    submodules/LukQml/LukQml.pro

SignUpForm.depends = submodules/LukQml/LukQml.pro
