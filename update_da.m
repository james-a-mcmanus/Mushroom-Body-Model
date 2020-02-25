function da = update_da(da, td, ba)

    da = da + (-da/td) + ba;

end