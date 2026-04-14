`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D = 4'b0000;
            WE = 0;
            RE = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Basic Write and Read (4'hA)", test_num);
            D = 4'hA; WE = 1; RE = 0;
            @(posedge clk);
            #1 WE = 0; RE = 1;
            #1 #1;
 check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Basic Write and Read (4'h5)", test_num);
            D = 4'h5; WE = 1; RE = 0;
            @(posedge clk);
            #1 WE = 0; RE = 1;
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Verify WE=0 prevents data overwrite", test_num);

            D = 4'h3; WE = 1; RE = 0;
            @(posedge clk);

            #1 D = 4'hC; WE = 0;
            @(posedge clk);
            #1 RE = 1;
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Verify Q retains last value when WE=0, RE=0", test_num);

            D = 4'h7; WE = 1; RE = 1;
            @(posedge clk);
            #1 WE = 0; RE = 1;
            #1 RE = 0;
            #1 #1;
 check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Write and Read 4'hF", test_num);
            D = 4'hF; WE = 1; RE = 1;
            @(posedge clk);
            #1 WE = 0;
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Write and Read 4'h0", test_num);
            D = 4'h0; WE = 1; RE = 1;
            @(posedge clk);
            #1 WE = 0;
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, RE, WE, clk, Q);
    end

endmodule
