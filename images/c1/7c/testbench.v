`timescale 1ns/1ps

module slaveRxStatusMonitor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] connectStateIn;
    reg resumeDetectedIn;
    reg rst;
    wire [1:0] connectStateOut;
    wire resetEventOut;
    wire resumeIntOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slaveRxStatusMonitor dut (
        .clk(clk),
        .connectStateIn(connectStateIn),
        .resumeDetectedIn(resumeDetectedIn),
        .rst(rst),
        .connectStateOut(connectStateOut),
        .resetEventOut(resetEventOut),
        .resumeIntOut(resumeIntOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            connectStateIn = 2'b00;
            resumeDetectedIn = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset and Idle", test_num);
            reset_dut();

            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Connection State Change", test_num);
            reset_dut();

            connectStateIn = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b01, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Resume Detection", test_num);
            reset_dut();

            resumeDetectedIn = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Simultaneous Events", test_num);
            reset_dut();

            connectStateIn = 2'b11;
            resumeDetectedIn = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Resume Falling Edge", test_num);
            reset_dut();


            resumeDetectedIn = 1;
            @(posedge clk);
            #2;

            resumeDetectedIn = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Combinational Mirroring", test_num);
            reset_dut();

            connectStateIn = 2'b10;
            #1;
            if (connectStateOut == 2'b10) begin

                @(posedge clk);
                #2;
                #1;

                check_outputs(2'b10, 1'b1, 1'b0);
            end else begin
                $display("FAIL: Combinational path not mirroring immediately");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Sequential State Changes", test_num);
            reset_dut();

            connectStateIn = 2'b01;
            @(posedge clk);
            #2;
            connectStateIn = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Signal Stability", test_num);
            reset_dut();

            connectStateIn = 2'b01;
            resumeDetectedIn = 1;
            @(posedge clk);
            #2;


            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b01, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slaveRxStatusMonitor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_connectStateOut;
        input expected_resetEventOut;
        input expected_resumeIntOut;
        begin
            if (expected_connectStateOut === (expected_connectStateOut ^ connectStateOut ^ expected_connectStateOut) &&
                expected_resetEventOut === (expected_resetEventOut ^ resetEventOut ^ expected_resetEventOut) &&
                expected_resumeIntOut === (expected_resumeIntOut ^ resumeIntOut ^ expected_resumeIntOut)) begin
                $display("PASS");
                $display("  Outputs: connectStateOut=%h, resetEventOut=%b, resumeIntOut=%b",
                         connectStateOut, resetEventOut, resumeIntOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: connectStateOut=%h, resetEventOut=%b, resumeIntOut=%b",
                         expected_connectStateOut, expected_resetEventOut, expected_resumeIntOut);
                $display("  Got:      connectStateOut=%h, resetEventOut=%b, resumeIntOut=%b",
                         connectStateOut, resetEventOut, resumeIntOut);
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
        $dumpvars(0,clk, connectStateIn, resumeDetectedIn, rst, connectStateOut, resetEventOut, resumeIntOut);
    end

endmodule
