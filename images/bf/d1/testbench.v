`timescale 1ns/1ps

module fasm_tparam_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] adr_i;
    reg clk_i;
    reg [5:0] dat_i;
    reg rst_i;
    reg stb_i;
    reg wre_i;
    reg [3:0] xadr_i;
    reg xclk_i;
    reg [5:0] xdat_i;
    reg xrst_i;
    reg xstb_i;
    reg xwre_i;
    wire [5:0] dat_o;
    wire [5:0] xdat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fasm_tparam dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .wre_i(wre_i),
        .xadr_i(xadr_i),
        .xclk_i(xclk_i),
        .xdat_i(xdat_i),
        .xrst_i(xrst_i),
        .xstb_i(xstb_i),
        .xwre_i(xwre_i),
        .dat_o(dat_o),
        .xdat_o(xdat_o)
    );

    // Clock generation (10ns period)
    initial begin
        xclk_i = 0;
        forever #5 xclk_i = ~xclk_i;
    end

        task reset_dut;

    begin
        adr_i = 0;
        clk_i = 0;
        dat_i = 0;
        rst_i = 0;
        stb_i = 0;
        wre_i = 0;
        xadr_i = 0;
        xdat_i = 0;
        xrst_i = 0;
        xstb_i = 0;
        xwre_i = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Auxiliary Write (Clocked)", test_num);

        @(posedge xclk_i);
        xadr_i = 4'h5;
        xdat_i = 6'h2A;
        xwre_i = 1;

        @(posedge xclk_i);
        xwre_i = 0;

        #5;
        adr_i = 4'h5;
        #5;


        #1;



        check_outputs(6'h2A, 6'bxxxxxx);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Primary Write (Asynchronous/Combinational)", test_num);

        adr_i = 4'hC;
        dat_i = 6'h1F;
        wre_i = 1;
        #10;
        wre_i = 0;
        #5;


        adr_i = 4'hC;
        #5;

        #1;


        check_outputs(6'h1F, 6'bxxxxxx);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Address Independence", test_num);


        adr_i = 4'h1;
        dat_i = 6'h11;
        wre_i = 1;
        #10;
        wre_i = 0;


        @(posedge xclk_i);
        xadr_i = 4'h2;
        xdat_i = 6'h22;
        xwre_i = 1;
        @(posedge xclk_i);
        xwre_i = 0;


        #5;
        adr_i = 4'h1;
        #5;
        if (dat_o !== 6'h11) begin
            $display("Sub-test Fail: Addr 1 corrupted");
        end


        adr_i = 4'h2;
        #5;

        #1;


        check_outputs(6'h22, 6'bxxxxxx);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Interface Overwrite", test_num);


        adr_i = 4'hF;
        dat_i = 6'h01;
        wre_i = 1;
        #10;
        wre_i = 0;


        @(posedge xclk_i);
        xadr_i = 4'hF;
        xdat_i = 6'h3F;
        xwre_i = 1;
        @(posedge xclk_i);
        xwre_i = 0;

        #5;
        adr_i = 4'hF;
        #5;

        #1;


        check_outputs(6'h3F, 6'bxxxxxx);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Boundary Address (Max)", test_num);

        @(posedge xclk_i);
        xadr_i = 4'hF;
        xdat_i = 6'h10;
        xwre_i = 1;
        @(posedge xclk_i);
        xwre_i = 0;

        #5;
        adr_i = 4'hF;
        #5;

        #1;


        check_outputs(6'h10, 6'bxxxxxx);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fasm_tparam Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [5:0] expected_dat_o;
        input [5:0] expected_xdat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_xdat_o === (expected_xdat_o ^ xdat_o ^ expected_xdat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h, xdat_o=%h",
                         dat_o, xdat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h, xdat_o=%h",
                         expected_dat_o, expected_xdat_o);
                $display("  Got:      dat_o=%h, xdat_o=%h",
                         dat_o, xdat_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,adr_i, clk_i, dat_i, rst_i, stb_i, wre_i, xadr_i, xclk_i, xdat_i, xrst_i, xstb_i, xwre_i, dat_o, xdat_o);
    end

endmodule
