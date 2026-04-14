`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_a;
    reg ack_b;
    reg clk;
    reg [7:0] data_in_a;
    reg [7:0] data_in_b;
    reg req_a;
    reg req_b;
    reg reset;
    wire active_channel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack_a(ack_a),
        .ack_b(ack_b),
        .clk(clk),
        .data_in_a(data_in_a),
        .data_in_b(data_in_b),
        .req_a(req_a),
        .req_b(req_b),
        .reset(reset),
        .active_channel(active_channel),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req_a = 0;
            req_b = 0;
            ack_a = 0;
            ack_b = 0;
            data_in_a = 8'h00;
            data_in_b = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel A Request Only", test_num);
            reset_dut();
            req_a = 1;
            req_b = 0;
            data_in_a = 8'hAA;
            data_in_b = 8'h00;
            ack_a = 1;
            ack_b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel B Request Only", test_num);
            reset_dut();
            req_a = 0;
            req_b = 1;
            data_in_a = 8'h00;
            data_in_b = 8'hBB;
            ack_a = 0;
            ack_b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Request - Priority A", test_num);
            reset_dut();
            req_a = 1;
            req_b = 1;
            data_in_a = 8'hA3;
            data_in_b = 8'hB3;
            ack_a = 1;
            ack_b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'hA3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Preemption (B active, A requests)", test_num);
            reset_dut();

            req_a = 0; req_b = 1; data_in_b = 8'h55; ack_b = 1;
            @(posedge clk);

            req_a = 1; data_in_a = 8'hAA; ack_a = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel A Release (Switch to B)", test_num);
            reset_dut();

            req_a = 1; req_b = 1;
            data_in_a = 8'hA1; data_in_b = 8'hB1;
            ack_a = 1; ack_b = 1;
            @(posedge clk);

            req_a = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'hB1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (No Requests)", test_num);
            reset_dut();
            req_a = 0;
            req_b = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h00);
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
        input expected_active_channel;
        input [7:0] expected_data_out;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%b, data_out=%h",
                         active_channel, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%b, data_out=%h",
                         expected_active_channel, expected_data_out);
                $display("  Got:      active_channel=%b, data_out=%h",
                         active_channel, data_out);
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
        $dumpvars(0,ack_a, ack_b, clk, data_in_a, data_in_b, req_a, req_b, reset, active_channel, data_out);
    end

endmodule
