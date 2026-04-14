`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg error_detected;
    reg rst;
    wire ack;
    wire [7:0] data_out;
    wire resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .error_detected(error_detected),
        .rst(rst),
        .ack(ack),
        .data_out(data_out),
        .resend(resend)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            error_detected = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Successful Transmission", test_num);
            reset_dut();


            data_in = 8'hA5;
            error_detected = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 8'hA5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transmission with Error Detected", test_num);
            reset_dut();


            data_in = 8'h5A;
            error_detected = 1;
            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Recovery after Resend Request", test_num);
            reset_dut();


            data_in = 8'hCC;
            error_detected = 1;
            @(posedge clk);
            #10;


            data_in = 8'hCC;
            error_detected = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 8'hCC, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multiple Sequential Successful Packets", test_num);
            reset_dut();


            data_in = 8'h11;
            error_detected = 0;
            @(posedge clk);
            #10;


            data_in = 8'h22;
            error_detected = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'h22, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Sustained Error Condition", test_num);
            reset_dut();


            data_in = 8'hFF;
            error_detected = 1;
            @(posedge clk);
            #10;
            @(posedge clk);
            #10;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: System Reset during operation", test_num);
            reset_dut();


            data_in = 8'hAA;
            error_detected = 0;
            @(posedge clk);
            #5;


            rst = 1;
            #20;
            rst = 0;
            #2;


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
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
        input expected_ack;
        input [7:0] expected_data_out;
        input expected_resend;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_resend === (expected_resend ^ resend ^ expected_resend)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, resend=%b",
                         ack, data_out, resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, resend=%b",
                         expected_ack, expected_data_out, expected_resend);
                $display("  Got:      ack=%b, data_out=%h, resend=%b",
                         ack, data_out, resend);
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
        $dumpvars(0,clk, data_in, error_detected, rst, ack, data_out, resend);
    end

endmodule
