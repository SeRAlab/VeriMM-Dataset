`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg send;
    wire [7:0] data_out;
    wire error;
    wire request;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .send(send),
        .data_out(data_out),
        .error(error),
        .request(request)
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
            send = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Success on first attempt", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;



            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hA5, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Success after one retry", test_num);
            reset_dut();

            data_in = 8'h3C;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;





            wait(request === 1'b1);
            $display("  Info: Retransmission request detected...");


            repeat(1) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h3C, 0, 0);
        end
        endtask

    task testcase003;

        integer attempts;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum attempts (3) and give up", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;



            attempts = 0;
            while (attempts < 3) begin
                @(posedge clk);
                if (request === 1'b1) begin
                    attempts = attempts + 1;
                    $display("  Info: Attempt %0d failed...", attempts);

                    wait(request === 1'b0);
                end


                if ($time > 5000) break;
            end

            repeat(5) @(posedge clk);



            #1;




            check_outputs(data_out, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bit pattern success", test_num);
            reset_dut();

            data_in = 8'h55;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h55, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: System reset during transmission", test_num);
            reset_dut();

            data_in = 8'hEE;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h00, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ Testbench");
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
        input [7:0] expected_data_out;
        input expected_error;
        input expected_request;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_request === (expected_request ^ request ^ expected_request)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b, request=%b",
                         data_out, error, request);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b, request=%b",
                         expected_data_out, expected_error, expected_request);
                $display("  Got:      data_out=%h, error=%b, request=%b",
                         data_out, error, request);
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
        $dumpvars(0,ack, clk, data_in, rst, send, data_out, error, request);
    end

endmodule
