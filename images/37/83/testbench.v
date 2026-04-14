`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [4:0] data_in;
    reg rst;
    wire [4:0] data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .state(state)
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
            data_in = 5'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Success on first try", test_num);
            reset_dut();

            data_in = 5'h0A;
            @(posedge clk);
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h0A, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Success on second attempt", test_num);
            reset_dut();

            data_in = 5'h15;
            @(posedge clk);
            @(posedge clk);

            ack = 0;
            @(posedge clk);
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h15, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Success on third attempt", test_num);
            reset_dut();

            data_in = 5'h1F;
            @(posedge clk);
            @(posedge clk);
            ack = 0;
            @(posedge clk);
            @(posedge clk);
            ack = 0;
            @(posedge clk);
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1F, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reach ERROR state after 3 failures", test_num);
            reset_dut();

            data_in = 5'h07;
            @(posedge clk);
            @(posedge clk);
            ack = 0;
            @(posedge clk);
            @(posedge clk);
            ack = 0;
            @(posedge clk);
            @(posedge clk);
            ack = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h07, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset recovery from ERROR state", test_num);
            reset_dut();


            data_in = 5'h01;
            @(posedge clk); @(posedge clk); ack = 0;
            @(posedge clk); @(posedge clk); ack = 0;
            @(posedge clk); @(posedge clk); ack = 0;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h00, 2'b00);
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
        input [4:0] expected_data_out;
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%h",
                         data_out, state);
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
        $dumpvars(0,ack, clk, data_in, rst, data_out, state);
    end

endmodule
