`timescale 1ns/1ps

module data_control_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control_in;
    reg [15:0] data_in;
    wire [3:0] control_out;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_control dut (
        .control_in(control_in),
        .data_in(data_in),
        .control_out(control_out),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic operation with zero and low values", test_num);
        data_in = 16'd0;
        control_in = 4'd0;

        #1;


        check_outputs(4'd0, 16'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Normal increment and shift", test_num);
        data_in = 16'd1024;
        control_in = 4'd5;

        #1;


        check_outputs(4'd10, 16'd1025);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Data input at maximum (overflow check)", test_num);
        data_in = 16'hFFFF;
        control_in = 4'd3;

        #1;


        check_outputs(4'd6, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Control input MSB shift (overflow check)", test_num);
        data_in = 16'd500;
        control_in = 4'b1011;

        #1;


        check_outputs(4'd6, 16'd501);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Maximum control input", test_num);
        data_in = 16'h1234;
        control_in = 4'hF;

        #1;


        check_outputs(4'd14, 16'h1235);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Data mid-range toggle", test_num);
        data_in = 16'h7FFF;
        control_in = 4'd8;

        #1;


        check_outputs(4'd0, 16'h8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_control Testbench");
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
        input [3:0] expected_control_out;
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_out === (expected_control_out ^ control_out ^ expected_control_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: control_out=%h, data_out=%h",
                         control_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_out=%h, data_out=%h",
                         expected_control_out, expected_data_out);
                $display("  Got:      control_out=%h, data_out=%h",
                         control_out, data_out);
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
