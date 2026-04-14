`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ABC;
    reg enable;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABC(ABC),
        .enable(enable),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        ABC = 3'b000; enable = 1'b0;
        $display("Test %0d: ABC=000, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ABC = 3'b001; enable = 1'b0;
        $display("Test %0d: ABC=001, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ABC = 3'b010; enable = 1'b0;
        $display("Test %0d: ABC=010, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ABC = 3'b011; enable = 1'b0;
        $display("Test %0d: ABC=011, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ABC = 3'b100; enable = 1'b0;
        $display("Test %0d: ABC=100, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ABC = 3'b101; enable = 1'b0;
        $display("Test %0d: ABC=101, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ABC = 3'b110; enable = 1'b0;
        $display("Test %0d: ABC=110, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b01000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ABC = 3'b111; enable = 1'b0;
        $display("Test %0d: ABC=111, enable=0 (Normal Operation)", test_num);
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ABC = 3'b000; enable = 1'b1;
        $display("Test %0d: ABC=000, enable=1 (Disabled)", test_num);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ABC = 3'b101; enable = 1'b1;
        $display("Test %0d: ABC=101, enable=1 (Disabled)", test_num);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        ABC = 3'b111; enable = 1'b1;
        $display("Test %0d: ABC=111, enable=1 (Disabled)", test_num);
        #1;

        check_outputs(8'b00000000);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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

endmodule
