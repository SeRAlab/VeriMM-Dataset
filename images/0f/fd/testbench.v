`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg [3:0] send_data;
    reg send_valid;
    wire data_valid;
    wire [3:0] frame_sent;
    wire [3:0] received_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_data(send_data),
        .send_valid(send_valid),
        .data_valid(data_valid),
        .frame_sent(frame_sent),
        .received_data(received_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_valid = 0;
            send_data = 0;
            ack = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Frame Transmission", test_num);
            reset_dut();


            @(posedge clk);
            #1;
            send_data = 4'hA;
            send_valid = 1;

            @(posedge clk);
            #1;
            send_valid = 0;



            wait(data_valid == 1);
            @(posedge clk);
            #1;
            ack = 1;

            @(posedge clk);
            #1;
            ack = 0;


            #1;



            check_outputs(1'b1, 4'hA, 4'hA);
        end
        endtask

    task testcase002;

        integer i;
        reg [3:0] test_vals [0:3];
        begin
            test_vals[0] = 4'h1; test_vals[1] = 4'h2;
            test_vals[2] = 4'h3; test_vals[3] = 4'h4;

            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Window (4 Frames)", test_num);
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
                send_data = test_vals[i];
                send_valid = 1;
                @(posedge clk);
                #1;
                send_valid = 0;


                wait(data_valid == 1);
                @(posedge clk);
                #1;
                ack = 1;
                @(posedge clk);
                #1;
                ack = 0;
            end


            #1;



            check_outputs(1'b1, 4'h4, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Window Full and Blocked", test_num);
            reset_dut();



            @(posedge clk); #1; send_data = 4'h1; send_valid = 1;
            @(posedge clk); #1; send_valid = 0;

            @(posedge clk); #1; send_data = 4'h2; send_valid = 1;
            @(posedge clk); #1; send_valid = 0;

            @(posedge clk); #1; send_data = 4'h3; send_valid = 1;
            @(posedge clk); #1; send_valid = 0;

            @(posedge clk); #1; send_data = 4'h4; send_valid = 1;
            @(posedge clk); #1; send_valid = 0;


            repeat(3) @(posedge clk);


            #1; ack = 1;
            @(posedge clk);
            #1; ack = 0;


            @(posedge clk); #1; send_data = 4'hF; send_valid = 1;
            @(posedge clk); #1; send_valid = 0;


            wait(data_valid == 1 && received_data == 4'hF);
            #1;

            check_outputs(1'b1, 4'hF, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();


            @(posedge clk);
            #1;
            send_data = 4'h5;
            send_valid = 1;


            @(posedge clk);
            #1;
            reset = 1;
            send_valid = 0;

            repeat(2) @(posedge clk);
            #1 reset = 0;


            repeat(1) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'h0, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_data_valid;
        input [3:0] expected_frame_sent;
        input [3:0] expected_received_data;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent) &&
                expected_received_data === (expected_received_data ^ received_data ^ expected_received_data)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, frame_sent=%h, received_data=%h",
                         data_valid, frame_sent, received_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, frame_sent=%h, received_data=%h",
                         expected_data_valid, expected_frame_sent, expected_received_data);
                $display("  Got:      data_valid=%b, frame_sent=%h, received_data=%h",
                         data_valid, frame_sent, received_data);
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
        $dumpvars(0,ack, clk, reset, send_data, send_valid, data_valid, frame_sent, received_data);
    end

endmodule
