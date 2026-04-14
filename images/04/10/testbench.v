`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg error;
    reg reset;
    wire ack;
    wire [3:0] attempts;
    wire [7:0] data_out;
    wire nack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .error(error),
        .reset(reset),
        .ack(ack),
        .attempts(attempts),
        .data_out(data_out),
        .nack(nack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            error = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful transmission (No Errors)", test_num);
            reset_dut();

            data_in = 8'hA5;
            error = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd1, 8'hA5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmission with one retransmission", test_num);
            reset_dut();

            data_in = 8'h55;
            error = 1;

            @(posedge clk);
            #1;


            error = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd2, 8'h55, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmission with two retransmissions", test_num);
            reset_dut();

            data_in = 8'hFF;
            error = 1;

            @(posedge clk);
            @(posedge clk);

            error = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd3, 8'hFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset behavior during transmission", test_num);
            reset_dut();

            data_in = 8'h12;
            error = 1;
            @(posedge clk);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;




            #1;





            check_outputs(1'b0, 4'd0, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Edge case data (0x00)", test_num);
            reset_dut();

            data_in = 8'h00;
            error = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd1, 8'h00, 1'b0);
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
        input [3:0] expected_attempts;
        input [7:0] expected_data_out;
        input expected_nack;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_attempts === (expected_attempts ^ attempts ^ expected_attempts) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_nack === (expected_nack ^ nack ^ expected_nack)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, attempts=%h, data_out=%h, nack=%b",
                         ack, attempts, data_out, nack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, attempts=%h, data_out=%h, nack=%b",
                         expected_ack, expected_attempts, expected_data_out, expected_nack);
                $display("  Got:      ack=%b, attempts=%h, data_out=%h, nack=%b",
                         ack, attempts, data_out, nack);
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
        $dumpvars(0,clk, data_in, error, reset, ack, attempts, data_out, nack);
    end

endmodule
