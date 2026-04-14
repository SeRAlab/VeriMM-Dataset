`timescale 1ns/1ps

module pcie_fsm_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_fsm dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .start(start),
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
            start = 0;
            ack = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE to REQUEST transition", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: REQUEST to RESPONSE transition via ack", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);


            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RESPONSE back to IDLE after cycles", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);


            ack = 1;
            @(posedge clk);
            #1 ack = 0;


            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Stay in IDLE if start is not asserted", test_num);
            reset_dut();

            ack = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Stay in REQUEST if ack is not asserted", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_fsm Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,ack, clk, rst, start, state);
    end

endmodule
