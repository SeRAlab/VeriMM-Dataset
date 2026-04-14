`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .command(command),
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
            command = 2'b00;
            @(posedge clk);
            #1;
            rst = 0;

        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: IDLE -> IDLE (cmd 00)", test_num);
        reset_dut();
        command = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: IDLE -> ACTIVE (cmd 01)", test_num);
        reset_dut();
        command = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ACTIVE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: IDLE -> SUSPEND (cmd 10)", test_num);
        reset_dut();
        command = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(SUSPEND);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: IDLE -> ERROR (cmd 11)", test_num);
        reset_dut();
        command = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ACTIVE -> IDLE (cmd 00)", test_num);
        reset_dut();
        command = 2'b01;
        @(posedge clk);
        #1;
        command = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ACTIVE -> ACTIVE (cmd 01)", test_num);
        reset_dut();
        command = 2'b01;
        @(posedge clk);
        #1;
        command = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ACTIVE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ACTIVE -> SUSPEND (cmd 10)", test_num);
        reset_dut();
        command = 2'b01;
        @(posedge clk);
        #1;
        command = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(SUSPEND);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ACTIVE -> ERROR (cmd 11)", test_num);
        reset_dut();
        command = 2'b01;
        @(posedge clk);
        #1;
        command = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUSPEND -> IDLE (cmd 00)", test_num);
        reset_dut();
        command = 2'b10;
        @(posedge clk);
        #1;
        command = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUSPEND -> ACTIVE (cmd 01)", test_num);
        reset_dut();
        command = 2'b10;
        @(posedge clk);
        #1;
        command = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ACTIVE);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUSPEND -> SUSPEND (cmd 10)", test_num);
        reset_dut();
        command = 2'b10;
        @(posedge clk);
        #1;
        command = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(SUSPEND);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUSPEND -> ERROR (cmd 11)", test_num);
        reset_dut();
        command = 2'b10;
        @(posedge clk);
        #1;
        command = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ERROR -> IDLE (cmd 00)", test_num);
        reset_dut();
        command = 2'b11;
        @(posedge clk);
        #1;
        command = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ERROR -> ACTIVE (cmd 01)", test_num);
        reset_dut();
        command = 2'b11;
        @(posedge clk);
        #1;
        command = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ACTIVE);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ERROR -> SUSPEND (cmd 10)", test_num);
        reset_dut();
        command = 2'b11;
        @(posedge clk);
        #1;
        command = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(SUSPEND);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ERROR -> ERROR (cmd 11)", test_num);
        reset_dut();
        command = 2'b11;
        @(posedge clk);
        #1;
        command = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ERROR);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        $dumpvars(0,clk, command, rst, state);
    end

endmodule
