`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_cmd;
    reg rst;
    reg write_cmd;
    wire operation_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .read_cmd(read_cmd),
        .rst(rst),
        .write_cmd(write_cmd),
        .operation_success(operation_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            read_cmd = 0;
            write_cmd = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Read Operation", test_num);
            reset_dut();
            @(posedge clk);
            read_cmd = 1;
            repeat(2) @(posedge clk);
            read_cmd = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Write Operation", test_num);
            reset_dut();
            @(posedge clk);
            write_cmd = 1;
            repeat(2) @(posedge clk);
            write_cmd = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Idle State No Commands", test_num);
            reset_dut();
            read_cmd = 0;
            write_cmd = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Read then Write", test_num);
            reset_dut();


            @(posedge clk);
            read_cmd = 1;
            repeat(2) @(posedge clk);
            read_cmd = 0;


            @(posedge clk);
            write_cmd = 1;
            repeat(2) @(posedge clk);
            write_cmd = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during operation", test_num);
            reset_dut();
            @(posedge clk);
            read_cmd = 1;
            @(posedge clk);
            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;
            read_cmd = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_operation_success;
        begin
            if (expected_operation_success === (expected_operation_success ^ operation_success ^ expected_operation_success)) begin
                $display("PASS");
                $display("  Outputs: operation_success=%b",
                         operation_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: operation_success=%b",
                         expected_operation_success);
                $display("  Got:      operation_success=%b",
                         operation_success);
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
        $dumpvars(0,clk, read_cmd, rst, write_cmd, operation_success);
    end

endmodule
