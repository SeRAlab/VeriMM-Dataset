`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frame_data;
    reg frame_valid;
    reg reset;
    wire [15:0] invalid_frame_count;
    wire [15:0] valid_frame_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_data(frame_data),
        .frame_valid(frame_valid),
        .reset(reset),
        .invalid_frame_count(invalid_frame_count),
        .valid_frame_count(valid_frame_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frame_data = 8'h00;
            frame_valid = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task send_frame;

        input [7:0] byte1;
        input [7:0] byte2;
        input [7:0] byte3;
        input [7:0] checksum;
        begin
            @(posedge clk);
            frame_valid = 1;
            frame_data = byte1; @(posedge clk);
            frame_data = byte2; @(posedge clk);
            frame_data = byte3; @(posedge clk);
            frame_data = checksum; @(posedge clk);
            frame_valid = 0;
            frame_data = 8'h00;
            repeat(3) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial State after Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Valid Frame", test_num);
            reset_dut();

            send_frame(8'hAA, 8'hBB, 8'hCC, 8'h9D);
            #1;

            check_outputs(16'h0000, 16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Invalid Frame", test_num);
            reset_dut();

            send_frame(8'hAA, 8'hBB, 8'hCC, 8'h00);
            #1;

            check_outputs(16'h0001, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Mixed Frames", test_num);
            reset_dut();

            send_frame(8'h01, 8'h02, 8'h03, (8'h01 ^ 8'h02 ^ 8'h03));

            send_frame(8'h10, 20, 30, 8'hFF);

            send_frame(8'hFF, 8'hEE, 8'hDD, (8'hFF ^ 8'hEE ^ 8'hDD));

            send_frame(8'h55, 8'hAA, 8'h00, (8'h55 ^ 8'hAA ^ 8'h00));

            #1;


            check_outputs(16'h0001, 16'h0003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset mid-operation", test_num);
            reset_dut();

            send_frame(8'h01, 8'h01, 8'h01, 8'h01);
            send_frame(8'h01, 8'h01, 8'h01, 8'h00);


            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Back-to-back Valid Frames", test_num);
            reset_dut();
            send_frame(8'h11, 8'h22, 8'h33, (8'h11^8'h22^8'h33));
            send_frame(8'h44, 8'h55, 8'h66, (8'h44^8'h55^8'h66));
            send_frame(8'h77, 8'h88, 8'h99, (8'h77^8'h88^8'h99));
            #1;

            check_outputs(16'h0000, 16'h0003);
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
        input [15:0] expected_invalid_frame_count;
        input [15:0] expected_valid_frame_count;
        begin
            if (expected_invalid_frame_count === (expected_invalid_frame_count ^ invalid_frame_count ^ expected_invalid_frame_count) &&
                expected_valid_frame_count === (expected_valid_frame_count ^ valid_frame_count ^ expected_valid_frame_count)) begin
                $display("PASS");
                $display("  Outputs: invalid_frame_count=%h, valid_frame_count=%h",
                         invalid_frame_count, valid_frame_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: invalid_frame_count=%h, valid_frame_count=%h",
                         expected_invalid_frame_count, expected_valid_frame_count);
                $display("  Got:      invalid_frame_count=%h, valid_frame_count=%h",
                         invalid_frame_count, valid_frame_count);
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
        $dumpvars(0,clk, frame_data, frame_valid, reset, invalid_frame_count, valid_frame_count);
    end

endmodule
