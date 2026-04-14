`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .we(we),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            ra1 = 0;
            ra2 = 0;
            wa = 0;
            wd = 0;
            we = 0;
            @(negedge c);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Simple Write and Read rd1", test_num);


            @(negedge c);
            wa = 5'd5;
            wd = 32'hDEADBEEF;
            we = 1;
            @(posedge c);


            @(negedge c);
            we = 0;
            ra1 = 5'd5;
            ra2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Dual Port Read", test_num);


            @(negedge c);
            wa = 5'd10; wd = 32'h12345678; we = 1;
            @(posedge c);


            @(negedge c);
            wa = 5'd20; wd = 32'h87654321; we = 1;
            @(posedge c);


            @(negedge c);
            we = 0;
            ra1 = 5'd10;
            ra2 = 5'd20;
            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write Enable Check", test_num);


            @(negedge c);
            wa = 5'd15; wd = 32'hAAAA_AAAA; we = 1;
            @(posedge c);


            @(negedge c);
            wa = 5'd15; wd = 32'hBBBB_BBBB; we = 0;
            @(posedge c);


            @(negedge c);
            ra1 = 5'd15;
            ra2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Simultaneous Read Same Reg", test_num);


            @(negedge c);
            wa = 5'd31; wd = 32'hFFFF_FFFF; we = 1;
            @(posedge c);


            @(negedge c);
            we = 0;
            ra1 = 5'd31;
            ra2 = 5'd31;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Overwrite Register", test_num);


            @(negedge c);
            wa = 5'd2; wd = 32'h1; we = 1;
            @(posedge c);


            @(negedge c);
            wa = 5'd2; wd = 32'h2; we = 1;
            @(posedge c);

            @(negedge c);
            we = 0;
            ra1 = 5'd2;
            #1;
            #1;

            check_outputs(32'h2, 32'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Register 0 Check", test_num);


            @(negedge c);
            wa = 5'd0; wd = 32'hCAFE_BABE; we = 1;
            @(posedge c);

            @(negedge c);
            we = 0;
            ra1 = 5'd0;
            #1;
            #1;

            check_outputs(32'hCAFE_BABE, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,c, ra1, ra2, wa, wd, we, rd1, rd2);
    end

endmodule
