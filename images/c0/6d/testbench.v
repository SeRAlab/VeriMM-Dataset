`timescale 1ns/1ps

module fasm_dpsram_wbr_tb;

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
    fasm_dpsram_wbr dut (
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
            adr_i  = 0;
            dat_i  = 0;
            rst_i  = 1;
            stb_i  = 0;
            wre_i  = 0;
            xadr_i = 0;
            xdat_i = 0;
            xrst_i = 1;
            xstb_i = 0;
            xwre_i = 0;
            repeat(2) @(posedge clk_i);
            rst_i  = 0;
            xrst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Port 1 Write then Read");


            @(posedge clk_i);
            adr_i = 8'h10; dat_i = 32'hDEADBEEF; wre_i = 1; stb_i = 1;
            @(posedge clk_i);
            stb_i = 0; wre_i = 0;


            @(posedge clk_i);
            adr_i = 8'h10; stb_i = 1; wre_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, xdat_o);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Port 2 Write then Read");


            @(posedge xclk_i);
            xadr_i = 8'h20; xdat_i = 32'hCAFEBABE; xwre_i = 1; xstb_i = 1;
            @(posedge xclk_i);
            xstb_i = 0; xwre_i = 0;


            @(posedge xclk_i);
            xadr_i = 8'h20; xstb_i = 1; xwre_i = 0;
            @(posedge xclk_i);
            #1;
            #1;

            check_outputs(dat_o, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Simultaneous Write to Different Addresses");

            fork
                begin
                    @(posedge clk_i);
                    adr_i = 8'h30; dat_i = 32'h11112222; wre_i = 1; stb_i = 1;
                    @(posedge clk_i);
                    stb_i = 0;
                end
                begin
                    @(posedge xclk_i);
                    xadr_i = 8'h40; xdat_i = 32'h33334444; xwre_i = 1; xstb_i = 1;
                    @(posedge xclk_i);
                    xstb_i = 0;
                end
            join


            fork
                begin
                    @(posedge clk_i);
                    adr_i = 8'h30; stb_i = 1; wre_i = 0;
                    @(posedge clk_i);
                end
                begin
                    @(posedge xclk_i);
                    xadr_i = 8'h40; xstb_i = 1; xwre_i = 0;
                    @(posedge xclk_i);
                end
            join
            #1;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Cross-Port Data Integrity");


            @(posedge clk_i);
            adr_i = 8'h55; dat_i = 32'h55AA55AA; wre_i = 1; stb_i = 1;
            @(posedge clk_i);
            stb_i = 0;


            @(posedge xclk_i);
            xadr_i = 8'h55; xstb_i = 1; xwre_i = 0;
            @(posedge xclk_i);
            #1;
            #1;

            check_outputs(dat_o, 32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Boundary Address Write (0xFF)");


            @(posedge clk_i);
            adr_i = 8'hFF; dat_i = 32'hFFFFFFFF; wre_i = 1; stb_i = 1;
            @(posedge clk_i);
            stb_i = 0;


            @(posedge clk_i);
            adr_i = 8'hFF; stb_i = 1; wre_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, xdat_o);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fasm_dpsram_wbr Testbench");
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
