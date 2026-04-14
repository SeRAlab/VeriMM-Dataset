`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] ack;
    wire [1:0] selected_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .ack(ack),
        .selected_channel(selected_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(4'b0000, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Request Channel 0", test_num);
            reset_dut();
            @(negedge clk) req = 4'b0001;
            @(posedge clk);
            #1;

            check_outputs(4'b0001, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Request Channel 3", test_num);
            reset_dut();
            @(negedge clk) req = 4'b1000;
            @(posedge clk);
            #1;

            check_outputs(4'b1000, 2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority Check (Req 3 and 0)", test_num);
            reset_dut();
            @(negedge clk) req = 4'b1001;
            @(posedge clk);
            #1;

            check_outputs(4'b1000, 2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority Check (Req 2 and 1)", test_num);
            reset_dut();
            @(negedge clk) req = 4'b0110;
            @(posedge clk);
            #1;

            check_outputs(4'b0100, 2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Channels Requesting (3 should win)", test_num);
            reset_dut();
            @(negedge clk) req = 4'b1111;
            @(posedge clk);
            #1;

            check_outputs(4'b1000, 2'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No Request Active", test_num);
            reset_dut();
            @(negedge clk) req = 4'b0000;
            @(posedge clk);
            #1;

            check_outputs(4'b0000, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_ack;
        input [1:0] expected_selected_channel;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_selected_channel === (expected_selected_channel ^ selected_channel ^ expected_selected_channel)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, selected_channel=%h",
                         ack, selected_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, selected_channel=%h",
                         expected_ack, expected_selected_channel);
                $display("  Got:      ack=%h, selected_channel=%h",
                         ack, selected_channel);
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
        $dumpvars(0,clk, req, rst, ack, selected_channel);
    end

endmodule
