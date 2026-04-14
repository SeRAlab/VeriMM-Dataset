`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg error_in;
    reg rst;
    wire ack;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .error_in(error_in),
        .rst(rst),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            error_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Successful Transmission", test_num);
            reset_dut();
            data_in = 8'hA5;
            error_in = 0;
            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Error Detection (No ACK)", test_num);
            reset_dut();
            data_in = 8'h33;
            error_in = 1;
            repeat (2) @(posedge clk);

            #1 #1;
 check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Error then Retransmission Success", test_num);
            reset_dut();


            data_in = 8'hFF;
            error_in = 1;
            @(posedge clk);


            error_in = 0;
            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Sequential Successful Transmissions", test_num);
            reset_dut();


            data_in = 8'h11;
            error_in = 0;
            @(posedge clk);


            data_in = 8'h22;
            error_in = 0;
            repeat (2) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Multiple Error Retries", test_num);
            reset_dut();

            data_in = 8'hBC;
            error_in = 1;
            repeat (3) @(posedge clk);

            error_in = 0;
            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hBC);
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
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, error_in, rst, ack, data_out);
    end

endmodule
