`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    reg reset;
    wire active;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .reset(reset),
        .active(active),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            connect = 0;
            disconnect = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset state is IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE to CONNECTED transition", test_num);
            reset_dut();
            @(negedge clk);
            connect = 1;
            @(posedge clk);
            #2 connect = 0;

            #1;


            check_outputs(1'b1, CONNECTED);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: CONNECTED to DISCONNECTED transition", test_num);
            reset_dut();

            @(negedge clk) connect = 1;
            @(posedge clk);

            @(negedge clk);
            connect = 0;
            disconnect = 1;
            @(posedge clk);
            #2 disconnect = 0;

            #1;


            check_outputs(1'b0, DISCONNECTED);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DISCONNECTED to CONNECTED transition", test_num);
            reset_dut();

            @(negedge clk) connect = 1;
            @(posedge clk);

            @(negedge clk) begin connect = 0; disconnect = 1; end
            @(posedge clk);

            @(negedge clk) begin disconnect = 0; connect = 1; end
            @(posedge clk);
            #2 connect = 0;

            #1;


            check_outputs(1'b1, CONNECTED);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Remain in IDLE on disconnect signal", test_num);
            reset_dut();
            @(negedge clk) disconnect = 1;
            @(posedge clk);
            #2 disconnect = 0;

            #1;


            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous connect/disconnect in CONNECTED state", test_num);
            reset_dut();

            @(negedge clk) connect = 1;
            @(posedge clk);

            @(negedge clk) begin connect = 1; disconnect = 1; end
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, DISCONNECTED);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input expected_active;
        input [1:0] expected_state;
        begin
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: active=%b, state=%h",
                         active, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, state=%h",
                         expected_active, expected_state);
                $display("  Got:      active=%b, state=%h",
                         active, state);
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
        $dumpvars(0,clk, connect, disconnect, reset, active, state);
    end

endmodule
