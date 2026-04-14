`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_read;
    reg start_write;
    wire [1:0] current_state;
    wire read_active;
    wire write_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .reset(reset),
        .start_read(start_read),
        .start_write(start_write),
        .current_state(current_state),
        .read_active(read_active),
        .write_active(write_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_read = 0;
            start_write = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset state (IDLE)", test_num);
            reset_dut();

            #1;


            check_outputs(IDLE, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Transition from IDLE to READ", test_num);
            reset_dut();
            start_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(READ, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Transition from IDLE to WRITE", test_num);
            reset_dut();
            start_write = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(WRITE, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Transition from READ back to IDLE", test_num);
            reset_dut();
            start_read = 1;
            @(posedge clk);
            #1 start_read = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Transition from WRITE back to IDLE", test_num);
            reset_dut();
            start_write = 1;
            @(posedge clk);
            #1 start_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Start Read and Start Write", test_num);
            reset_dut();
            start_read = 1;
            start_write = 1;
            @(posedge clk);
            #1;

            if (current_state == READ)
                #1;

                check_outputs(READ, 1'b1, 1'b0);
            else
                #1;

                check_outputs(WRITE, 1'b0, 1'b1);
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
        input [1:0] expected_current_state;
        input expected_read_active;
        input expected_write_active;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_read_active === (expected_read_active ^ read_active ^ expected_read_active) &&
                expected_write_active === (expected_write_active ^ write_active ^ expected_write_active)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, read_active=%b, write_active=%b",
                         current_state, read_active, write_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, read_active=%b, write_active=%b",
                         expected_current_state, expected_read_active, expected_write_active);
                $display("  Got:      current_state=%h, read_active=%b, write_active=%b",
                         current_state, read_active, write_active);
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
        $dumpvars(0,clk, reset, start_read, start_write, current_state, read_active, write_active);
    end

endmodule
