`timescale 1ns/1ps

module fasm_tpsram_wbr_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adr_i;
    reg clk_i;
    reg [31:0] dat_i;
    reg rst_i;
    reg stb_i;
    reg wre_i;
    reg [7:0] xadr_i;
    reg xclk_i;
    reg [31:0] xdat_i;
    reg xrst_i;
    reg xstb_i;
    reg xwre_i;
    wire [31:0] dat_o;
    wire [31:0] xdat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fasm_tpsram_wbr dut (
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
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            adr_i = 0;
            dat_i = 0;
            rst_i = 1;
            stb_i = 0;
            wre_i = 0;
            xadr_i = 0;
            xdat_i = 0;
            xrst_i = 1;
            xstb_i = 0;
            xwre_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            xrst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Primary Port Write and Read");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h10;
            dat_i = 32'h11223344;
            stb_i = 1;
            wre_i = 1;
            @(posedge clk_i);
            stb_i = 0;
            wre_i = 0;


            @(posedge clk_i);
            adr_i = 8'h10;
            stb_i = 1;
            wre_i = 0;
            @(posedge clk_i);
            stb_i = 0;


            #2;
            #1;

            check_outputs(32'h11223344, xdat_o);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Secondary Port Write and Read");
            reset_dut();


            @(posedge xclk_i);
            xadr_i = 8'h20;
            xdat_i = 32'hAABBCCDD;
            xstb_i = 1;
            xwre_i = 1;
            @(posedge xclk_i);
            xstb_i = 0;
            xwre_i = 0;


            @(posedge xclk_i);
            xadr_i = 8'h20;
            xstb_i = 1;
            xwre_i = 0;
            @(posedge xclk_i);
            xstb_i = 0;

            #2;
            #1;

            check_outputs(dat_o, 32'hAABBCCDD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Port A Write, Port B Read same address");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h30;
            dat_i = 32'h55AA55AA;
            stb_i = 1;
            wre_i = 1;
            @(posedge clk_i);
            stb_i = 0;
            wre_i = 0;


            @(posedge xclk_i);
            xadr_i = 8'h30;
            xstb_i = 1;
            xwre_i = 0;
            @(posedge xclk_i);
            xstb_i = 0;

            #2;
            #1;

            check_outputs(dat_o, 32'h55AA55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Simultaneous Writes to different addresses");
            reset_dut();

            @(posedge clk_i);

            adr_i = 8'h40; dat_i = 32'h0000AAAA; stb_i = 1; wre_i = 1;

            xadr_i = 8'h50; xdat_i = 32'h0000BBBB; xstb_i = 1; xwre_i = 1;

            @(posedge clk_i);
            stb_i = 0; wre_i = 0;
            xstb_i = 0; xwre_i = 0;


            @(posedge clk_i);
            adr_i = 8'h40; stb_i = 1;
            xadr_i = 8'h50; xstb_i = 1;
            @(posedge clk_i);
            stb_i = 0; xstb_i = 0;

            #2;
            #1;

            check_outputs(32'h0000AAAA, 32'h0000BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Write Enable and Strobe Gate Check");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h60; dat_i = 32'hCAFE0000; stb_i = 1; wre_i = 1;
            @(posedge clk_i);


            adr_i = 8'h60; dat_i = 32'hDEADBEEF; stb_i = 1; wre_i = 0;
            @(posedge clk_i);


            adr_i = 8'h60; dat_i = 32'hBAD0BAD0; stb_i = 0; wre_i = 1;
            @(posedge clk_i);


            adr_i = 8'h60; stb_i = 1; wre_i = 0;
            @(posedge clk_i);
            stb_i = 0;

            #2;

            #1;


            check_outputs(32'hCAFE0000, xdat_o);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Output Persistence (Last Accessed Data)");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h70; dat_i = 32'h99887766; stb_i = 1; wre_i = 1;
            @(posedge clk_i);


            stb_i = 0;
            adr_i = 8'hFF;

            repeat (5) @(posedge clk_i);

            #2;

            #1;


            check_outputs(32'h99887766, xdat_o);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fasm_tpsram_wbr Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_dat_o;
        input [31:0] expected_xdat_o;
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
