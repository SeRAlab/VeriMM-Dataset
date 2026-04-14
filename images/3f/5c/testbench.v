`timescale 1ns/1ps

module virtual_memory_unit_tb;

    // Testbench signals (sequential circuit)
    reg [19:0] base_address;
    reg clk;
    reg [11:0] logical_address;
    wire [19:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_unit dut (
        .base_address(base_address),
        .clk(clk),
        .logical_address(logical_address),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            base_address <= 20'h0;
            logical_address <= 12'h0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Values", test_num);
            reset_dut();
            base_address <= 20'h00000;
            logical_address <= 12'h000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Mapping", test_num);
            reset_dut();
            base_address <= 20'h12345;
            logical_address <= 12'h678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h129BD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Base, Zero Logical", test_num);
            reset_dut();
            base_address <= 20'hF0000;
            logical_address <= 12'h000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'hF0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Logical Address", test_num);
            reset_dut();
            base_address <= 20'hA0000;
            logical_address <= 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'hA0FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit Overflow Wrap", test_num);
            reset_dut();
            base_address <= 20'hFFFFF;
            logical_address <= 12'h001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values Overflow Wrap", test_num);
            reset_dut();
            base_address <= 20'hFFFFF;
            logical_address <= 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h00FFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Middle Range Offset", test_num);
            reset_dut();
            base_address <= 20'h80000;
            logical_address <= 12'h800;
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h80800);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_unit Testbench");
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
        input [19:0] expected_physical_address;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h",
                         physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h",
                         expected_physical_address);
                $display("  Got:      physical_address=%h",
                         physical_address);
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
        $dumpvars(0,base_address, clk, logical_address, physical_address);
    end

endmodule
