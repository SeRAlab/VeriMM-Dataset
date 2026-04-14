`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_bit;
    wire ack_signal;
    wire send_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send_bit(send_bit),
        .ack_signal(ack_signal),
        .send_signal(send_signal)
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
            send_bit = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Send bit 1 with ACK", test_num);
            reset_dut();


            send_bit = 1;
            @(posedge clk);



            #1 ack = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Send bit 1 without ACK (Persistence/Retry)", test_num);
            reset_dut();

            send_bit = 1;
            ack = 0;


            repeat(5) @(posedge clk);
            #1;



            #1;




            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Send bit 0 with ACK", test_num);
            reset_dut();

            send_bit = 0;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1;




            #1;





            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential transmission 1 then 0", test_num);
            reset_dut();


            send_bit = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);


            #1 ack = 0;
            send_bit = 0;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
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
        input expected_ack_signal;
        input expected_send_signal;
        begin
            if (expected_ack_signal === (expected_ack_signal ^ ack_signal ^ expected_ack_signal) &&
                expected_send_signal === (expected_send_signal ^ send_signal ^ expected_send_signal)) begin
                $display("PASS");
                $display("  Outputs: ack_signal=%b, send_signal=%b",
                         ack_signal, send_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_signal=%b, send_signal=%b",
                         expected_ack_signal, expected_send_signal);
                $display("  Got:      ack_signal=%b, send_signal=%b",
                         ack_signal, send_signal);
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
        $dumpvars(0,ack, clk, rst, send_bit, ack_signal, send_signal);
    end

endmodule
