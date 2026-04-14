`timescale 1ns/1ps

module memory_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [1:0] operation;
    reg reset;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_controller dut (
        .address(address),
        .clk(clk),
        .operation(operation),
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
            address = 4'd0;
            operation = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check status after reset", test_num);
            reset_dut();
            address = 4'd5;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate address 7", test_num);
            reset_dut();

            address = 4'd7;
            operation = 2'b01;
            @(posedge clk);
            #1;

            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate and then Free address 3", test_num);
            reset_dut();

            address = 4'd3;
            operation = 2'b01;
            @(posedge clk);
            #1;

            address = 4'd3;
            operation = 2'b10;
            @(posedge clk);
            #1;

            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address isolation check (Set 2, check 3)", test_num);
            reset_dut();

            address = 4'd2;
            operation = 2'b01;
            @(posedge clk);
            #1;

            address = 4'd3;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple concurrent-style allocations", test_num);
            reset_dut();

            address = 4'd1; operation = 2'b01; @(posedge clk); #1;

            address = 4'd10; operation = 2'b01; @(posedge clk); #1;

            address = 4'd15; operation = 2'b01; @(posedge clk); #1;


            address = 4'd10;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-allocate previously freed memory", test_num);
            reset_dut();

            address = 4'd12; operation = 2'b01; @(posedge clk); #1;
            address = 4'd12; operation = 2'b10; @(posedge clk); #1;
            address = 4'd12; operation = 2'b01; @(posedge clk); #1;

            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case address 0", test_num);
            reset_dut();
            address = 4'd0;
            operation = 2'b01;
            @(posedge clk);
            #1;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case address 15", test_num);
            reset_dut();
            address = 4'd15;
            operation = 2'b01;
            @(posedge clk);
            #1;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_controller Testbench");
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
        input expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%b",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%b",
                         expected_status);
                $display("  Got:      status=%b",
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
        $dumpvars(0,address, clk, operation, reset, status);
    end

endmodule
