`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg control;
    reg [4:0] data_in;
    wire [4:0] data_out;
    wire transmitted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out),
        .transmitted(transmitted)
    );

    // Clock generation (10ns period)
    initial begin
        control = 0;
        forever #5 control = ~control;
    end

        task reset_dut;

        begin
            data_in = 5'b0;

            @(posedge control);
            @(negedge control);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Store and Transmit Data 5'h0A", test_num);
            reset_dut();
            data_in = 5'h0A;

            @(posedge control);
            #2;
            #1;

            check_outputs(5'h0A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Store and Transmit Data 5'h15", test_num);
            reset_dut();
            data_in = 5'h15;
            @(posedge control);
            #2;
            #1;

            check_outputs(5'h15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Store and Transmit Data 5'h1F", test_num);
            reset_dut();
            data_in = 5'h1F;
            @(posedge control);
            #2;
            #1;

            check_outputs(5'h1F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Store and Transmit Data 5'h00", test_num);
            reset_dut();
            data_in = 5'h00;
            @(posedge control);
            #2;
            #1;

            check_outputs(5'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Store and Transmit Data 5'h11", test_num);
            reset_dut();
            data_in = 5'h11;
            @(posedge control);
            #2;
            #1;

            check_outputs(5'h11, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [4:0] expected_data_out;
        input expected_transmitted;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transmitted === (expected_transmitted ^ transmitted ^ expected_transmitted)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transmitted=%b",
                         data_out, transmitted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transmitted=%b",
                         expected_data_out, expected_transmitted);
                $display("  Got:      data_out=%h, transmitted=%b",
                         data_out, transmitted);
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
        $dumpvars(0,control, data_in, data_out, transmitted);
    end

endmodule
