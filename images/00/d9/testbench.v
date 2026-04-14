`timescale 1ns/1ps

module bluetooth_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    reg reset;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_fsm dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .reset(reset),
        .status(status)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IDLE to CONNECTED", test_num);
            reset_dut();

            connect = 1;
            disconnect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CONNECTED to DISCONNECTED", test_num);
            reset_dut();


            connect = 1;
            @(posedge clk);
            #1;


            connect = 0;
            disconnect = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DISCONNECTED to CONNECTED", test_num);
            reset_dut();


            connect = 1;
            @(posedge clk);
            #1;

            connect = 0;
            disconnect = 1;
            @(posedge clk);
            #1;

            disconnect = 0;
            connect = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Remain in IDLE", test_num);
            reset_dut();

            connect = 0;
            disconnect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Remain in CONNECTED", test_num);
            reset_dut();


            connect = 1;
            @(posedge clk);
            #1;


            connect = 0;
            disconnect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Remain in DISCONNECTED", test_num);
            reset_dut();


            connect = 1;
            @(posedge clk);
            #1;

            connect = 0;
            disconnect = 1;
            @(posedge clk);
            #1;


            connect = 0;
            disconnect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Loop Cycle", test_num);
            reset_dut();


            connect = 1; disconnect = 0;
            @(posedge clk); #1;


            connect = 0; disconnect = 1;
            @(posedge clk); #1;


            connect = 1; disconnect = 0;
            @(posedge clk); #1;


            connect = 0; disconnect = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_fsm Testbench");
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
        input [1:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,clk, connect, disconnect, reset, status);
    end

endmodule
