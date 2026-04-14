`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_data;
    wire data_sent;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_data(send_data),
        .data_sent(data_sent),
        .retransmit(retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            send_data = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successful Transmission", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Timeout and Retransmission", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;



            repeat(20) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Success After Retransmission", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(20) @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle State Check", test_num);
            reset_dut();


            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Late ACK handling", test_num);
            reset_dut();

            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(19) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_data_sent;
        input expected_retransmit;
        begin
            if (expected_data_sent === (expected_data_sent ^ data_sent ^ expected_data_sent) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_sent=%b, retransmit=%b",
                         data_sent, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_sent=%b, retransmit=%b",
                         expected_data_sent, expected_retransmit);
                $display("  Got:      data_sent=%b, retransmit=%b",
                         data_sent, retransmit);
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
        $dumpvars(0,ack, clk, reset, send_data, data_sent, retransmit);
    end

endmodule
