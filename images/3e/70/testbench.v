`timescale 1ns/1ps

module sliding_window_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] packet_num;
    reg packet_valid;
    reg reset;
    wire [3:0] ack_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_receiver dut (
        .clk(clk),
        .packet_num(packet_num),
        .packet_valid(packet_valid),
        .reset(reset),
        .ack_num(ack_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            packet_num = 0;
            packet_valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential In-order Reception", test_num);
            reset_dut();

            @(negedge clk);
            packet_valid = 1; packet_num = 4'd0; @(negedge clk);
            packet_valid = 1; packet_num = 4'd1; @(negedge clk);
            packet_valid = 1; packet_num = 4'd2; @(negedge clk);
            packet_valid = 1; packet_num = 4'd3; @(negedge clk);
            packet_valid = 0;

            #1;


            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ignore Packets Outside Window", test_num);
            reset_dut();

            @(negedge clk);
            packet_valid = 1; packet_num = 4'd5; @(negedge clk);
            packet_valid = 0;




            if (ack_num == 4'd5) fail_count = fail_count + 1;
            else #1;
 check_outputs(ack_num);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Out-of-order Within Window", test_num);
            reset_dut();

            @(negedge clk);
            packet_valid = 1; packet_num = 4'd0; @(negedge clk);
            packet_valid = 1; packet_num = 4'd2; @(negedge clk);
            packet_valid = 0;

            #1;


            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence Number Wrap-around (15 to 0)", test_num);
            reset_dut();

            for (i = 0; i <= 15; i = i + 1) begin
                @(negedge clk);
                packet_valid = 1;
                packet_num = i[3:0];
            end

            @(negedge clk);
            packet_valid = 1;
            packet_num = 4'd0;
            @(negedge clk);
            packet_valid = 0;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Valid Signal Toggle", test_num);
            reset_dut();

            @(negedge clk);
            packet_valid = 1; packet_num = 4'd0; @(negedge clk);
            packet_valid = 0; packet_num = 4'd1; @(negedge clk);
            packet_valid = 1; packet_num = 4'd1; @(negedge clk);
            packet_valid = 0;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Window Boundary Jump", test_num);
            reset_dut();

            @(negedge clk);
            packet_valid = 1; packet_num = 4'd0; @(negedge clk);
            packet_valid = 1; packet_num = 4'd4; @(negedge clk);
            packet_valid = 0;

            #1;


            check_outputs(4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_receiver Testbench");
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
        input [3:0] expected_ack_num;
        begin
            if (expected_ack_num === (expected_ack_num ^ ack_num ^ expected_ack_num)) begin
                $display("PASS");
                $display("  Outputs: ack_num=%h",
                         ack_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_num=%h",
                         expected_ack_num);
                $display("  Got:      ack_num=%h",
                         ack_num);
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
        $dumpvars(0,clk, packet_num, packet_valid, reset, ack_num);
    end

endmodule
