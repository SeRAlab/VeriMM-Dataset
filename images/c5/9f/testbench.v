`timescale 1ns/1ps

module bit_selector_tb;

    // Testbench signals (sequential circuit)
    reg control_signal;
    reg [3:0] in_signal;
    wire [1:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_selector dut (
        .control_signal(control_signal),
        .in_signal(in_signal),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        control_signal = 0;
        forever #5 control_signal = ~control_signal;
    end

        task reset_dut;

        begin
            in_signal = 4'b0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Input 4'b1101, Control 0->1 (Expected: inverted MSB '00')", test_num);
            @(negedge control_signal);
            in_signal = 4'b1101;
            @(posedge control_signal);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Input 4'b1011, Control 1->0 (Expected: non-inverted MSB '10')", test_num);
            @(posedge control_signal);
            in_signal = 4'b1011;
            @(negedge control_signal);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Input 4'b0110, Control 0->1 (Expected: inverted MSB '10')", test_num);
            @(negedge control_signal);
            in_signal = 4'b0110;
            @(posedge control_signal);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Input 4'b0011, Control 1->0 (Expected: non-inverted MSB '00')", test_num);
            @(posedge control_signal);
            in_signal = 4'b0011;
            @(negedge control_signal);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Stability test - Change input while control_signal is stable", test_num);


            @(negedge control_signal);
            in_signal = 4'b1111;
            @(posedge control_signal);
            #1;


            in_signal = 4'b0000;
            #2;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Consecutive edge updates", test_num);

            @(negedge control_signal);
            in_signal = 4'b1100;
            @(posedge control_signal);
            #1;

            in_signal = 4'b0100;
            @(negedge control_signal);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_selector Testbench");
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
        input [1:0] expected_out_signal;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,control_signal, in_signal, out_signal);
    end

endmodule
