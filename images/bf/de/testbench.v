`timescale 1ns/1ps

module fasm_spsram_wbr_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adr_i;
    reg clk_i;
    reg [31:0] dat_i;
    reg rst_i;
    reg stb_i;
    reg wre_i;
    wire [31:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fasm_spsram_wbr dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .wre_i(wre_i),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            adr_i = 8'h0;
            dat_i = 32'h0;
            stb_i = 0;
            wre_i = 0;
            rst_i = 1;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write then Read...");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h10;
            dat_i = 32'hDEADBEEF;
            stb_i = 1;
            wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h10;
            stb_i = 1;
            wre_i = 0;


            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Multiple Writes...");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h20; dat_i = 32'h11111111; stb_i = 1; wre_i = 1;

            @(posedge clk_i);
            adr_i = 8'h21; dat_i = 32'h22222222; stb_i = 1; wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h20; stb_i = 1; wre_i = 0;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Strobe Signal Validation...");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h30; dat_i = 32'hAAAAAAAA; stb_i = 1; wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h30; dat_i = 32'hBBBBBBBB; stb_i = 0; wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h30; stb_i = 1; wre_i = 0;

            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Write Enable Validation...");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h40; dat_i = 32'h55555555; stb_i = 1; wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h40; dat_i = 32'h66666666; stb_i = 1; wre_i = 0;


            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Data Persistence...");
            reset_dut();


            @(posedge clk_i);
            adr_i = 8'h50; dat_i = 32'hCAFEBABE; stb_i = 1; wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h60; dat_i = 32'hBAADF00D; stb_i = 1; wre_i = 1;


            @(posedge clk_i);
            adr_i = 8'h50; stb_i = 1; wre_i = 0;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fasm_spsram_wbr Testbench");
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
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h",
                         dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h",
                         expected_dat_o);
                $display("  Got:      dat_o=%h",
                         dat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, rst_i, stb_i, wre_i, dat_o);
    end

endmodule
