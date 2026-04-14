`timescale 1ns/1ps

module SRAM_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [7:0] D;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_8bit dut (
        .A(A),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        WE = 0;
        forever #5 WE = ~WE;
    end

        task reset_dut;

        begin
            A = 4'h0;
            D = 8'h00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Write/Read Address 0x0", test_num);
            reset_dut();
            @(posedge WE);
            A = 4'h0; D = 8'hAA;
            @(negedge WE);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Boundary Address Check (0xF)", test_num);
            reset_dut();
            @(posedge WE);
            A = 4'hF; D = 8'h55;
            @(negedge WE);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Overwrite Data Check", test_num);
            reset_dut();
            @(posedge WE); A = 4'h5; D = 8'h11;
            @(posedge WE); A = 4'h5; D = 8'h22;
            @(negedge WE);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Address Independence Check", test_num);
            reset_dut();
            @(posedge WE); A = 4'hA; D = 8'hA5;
            @(posedge WE); A = 4'hB; D = 8'h5A;
            @(negedge WE); A = 4'hA;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Zero Data Pattern Check", test_num);
            reset_dut();
            @(posedge WE); A = 4'h7; D = 8'h00;
            @(negedge WE);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_8bit Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,A, D, WE, Q);
    end

endmodule
