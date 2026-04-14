`timescale 1ns/1ps

module wifi_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect_req;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_control dut (
        .clk(clk),
        .connect_req(connect_req),
        .rst(rst),
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
            connect_req = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify DISCONNECTED state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(DISCONNECTED);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify transition to CONNECTING on connect_req", test_num);
            reset_dut();
            connect_req = 1;
            @(posedge clk);
            #1 connect_req = 0;
            @(posedge clk);

            #1;


            check_outputs(CONNECTING);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify transition to CONNECTED after CONNECT_TIME", test_num);
            reset_dut();
            connect_req = 1;
            @(posedge clk);
            #1 connect_req = 0;


            repeat (20) @(posedge clk);


            #1;



            check_outputs(CONNECTED);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset interruption while CONNECTING", test_num);
            reset_dut();
            connect_req = 1;
            @(posedge clk);
            #1 connect_req = 0;
            repeat (2) @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            #1;



            check_outputs(DISCONNECTED);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset return to DISCONNECTED from CONNECTED", test_num);
            reset_dut();
            connect_req = 1;
            @(posedge clk);
            #1 connect_req = 0;
            repeat (20) @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            #1;



            check_outputs(DISCONNECTED);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify module stays CONNECTED without further requests", test_num);
            reset_dut();
            connect_req = 1;
            @(posedge clk);
            #1 connect_req = 0;
            repeat (20) @(posedge clk);

            repeat (10) @(posedge clk);


            #1;



            check_outputs(CONNECTED);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_control Testbench");
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
        $dumpvars(0,clk, connect_req, rst, state);
    end

endmodule
