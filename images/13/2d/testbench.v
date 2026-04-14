`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [7:0] in_signal;
    wire [7:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .control(control),
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        control = 2'b00;
        in_signal = 8'd0;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        control = 2'b00;
        in_signal = 8'd128;
        #10;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        control = 2'b00;
        in_signal = 8'd255;
        #10;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        control = 2'b01;
        in_signal = 8'd0;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        control = 2'b01;
        in_signal = 8'd128;
        #10;
        #1;

        check_outputs(8'd64);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        control = 2'b01;
        in_signal = 8'd255;
        #10;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        control = 2'b10;
        in_signal = 8'd128;
        #10;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        control = 2'b10;
        in_signal = 8'd255;
        #10;
        #1;

        check_outputs(8'd63);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        control = 2'b11;
        in_signal = 8'd128;
        #10;
        #1;

        check_outputs(8'd16);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        control = 2'b11;
        in_signal = 8'd255;
        #10;
        #1;

        check_outputs(8'd31);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [7:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
