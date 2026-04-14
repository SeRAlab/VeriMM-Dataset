`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [4:0] data_in;
    reg rst;
    wire ack_out;
    wire [4:0] data_out;
    wire error_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .ack_out(ack_out),
        .data_out(data_out),
        .error_detected(error_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Reset State", test_num);
            reset_dut();
            #1;

            #1;


            check_outputs(0, 5'b00000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successful Transmission (Even Parity)", test_num);
            reset_dut();
            data_in = 5'b01010;
            ack = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 5'b01010, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Error Detection (Odd Parity)", test_num);
            reset_dut();
            data_in = 5'b01110;
            ack = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 5'b01110, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros Check", test_num);
            reset_dut();
            data_in = 5'b00000;
            ack = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 5'b00000, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Retransmission Logic (NACK response)", test_num);
            reset_dut();
            data_in = 5'b11000;
            ack = 0;
            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(1, 5'b11000, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High Bit Density (Odd Parity Error)", test_num);
            reset_dut();
            data_in = 5'b11111;
            ack = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 5'b11111, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
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
        input expected_ack_out;
        input [4:0] expected_data_out;
        input expected_error_detected;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_detected === (expected_error_detected ^ error_detected ^ expected_error_detected)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, data_out=%h, error_detected=%b",
                         ack_out, data_out, error_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, data_out=%h, error_detected=%b",
                         expected_ack_out, expected_data_out, expected_error_detected);
                $display("  Got:      ack_out=%b, data_out=%h, error_detected=%b",
                         ack_out, data_out, error_detected);
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
        $dumpvars(0,ack, clk, data_in, rst, ack_out, data_out, error_detected);
    end

endmodule
