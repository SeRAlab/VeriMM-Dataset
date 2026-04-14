`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    reg [2:0] phase_shift;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .data_in(data_in),
        .phase_shift(phase_shift),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 0 (Identity)", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd0;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 1", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd1;
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 2", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd2;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 3", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd3;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 4", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd4;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 5 (Wraps to 0)", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd5;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 6 (Wraps to 1)", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd6;
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Phase Shift 7 (Wraps to 2)", test_num);
        data_in = 5'b10000;
        phase_shift = 3'd7;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Wrap LSB to MSB (Shift 00001 by 1)", test_num);
        data_in = 5'b00001;
        phase_shift = 3'd1;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complex Pattern Shift", test_num);
        data_in = 5'b11010;
        phase_shift = 3'd2;

        #1;


        check_outputs(5'b10110);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        data_in = 5'b11111;
        phase_shift = 3'd4;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        data_in = 5'b00000;
        phase_shift = 3'd3;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        testcase012();
        
        
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
        input [4:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
