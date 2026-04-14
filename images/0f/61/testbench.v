`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg data_valid;
    reg reset;
    wire ack;
    wire retransmit;
    wire [4:0] sent_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .ack(ack),
        .retransmit(retransmit),
        .sent_data(sent_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            data_in = 5'b0;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Successful Transmission", test_num);
            reset_dut();


            data_in = 5'b10101;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;



            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmission of All Zeros", test_num);
            reset_dut();

            data_in = 5'b00000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmission of All Ones", test_num);
            reset_dut();

            data_in = 5'b11111;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Idle State Check", test_num);
            reset_dut();

            data_in = 5'b10110;
            data_valid = 0;

            repeat(4) @(posedge clk);




            #1;





            check_outputs(1'b0, 1'b0, 5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Transmission Check", test_num);
            reset_dut();


            data_in = 5'b01010;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);


            data_in = 5'b11001;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 5'b11001);
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
        input expected_retransmit;
        input [4:0] expected_sent_data;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit) &&
                expected_sent_data === (expected_sent_data ^ sent_data ^ expected_sent_data)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, retransmit=%b, sent_data=%h",
                         ack, retransmit, sent_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, retransmit=%b, sent_data=%h",
                         expected_ack, expected_retransmit, expected_sent_data);
                $display("  Got:      ack=%b, retransmit=%b, sent_data=%h",
                         ack, retransmit, sent_data);
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
        $dumpvars(0,clk, data_in, data_valid, reset, ack, retransmit, sent_data);
    end

endmodule
