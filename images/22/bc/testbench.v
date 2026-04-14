`timescale 1ns/1ps

module mmu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] virtual_address;
    wire [1:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mmu dut (
        .clk(clk),
        .reset(reset),
        .virtual_address(virtual_address),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            virtual_address = 4'h0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Virtual Address 0x0 (Page 0)", test_num);
            reset_dut();
            virtual_address = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'h0);
        end
        endtask

    task testcases1;
`. I will follow the user's specific naming instruction: "Name each testcase task using zero-padded numbers like: testcase001, testcase002, etc."

    Let's create 6 test cases.

    1. VA = 0 (Start of Page 0)
    2. VA = 3 (End of Page 0)
    3. VA = 4 (Start of Page 1)
    4. VA = 9 (Middle of Page 2)
    5. VA = 12 (Start of Page 3)
    6. VA = 15 (End of Page 3)

    This covers the full range and boundaries.

    *Clocking consideration:* In many sequential designs, the output might take one cycle to update. I will wait for one positive edge of the clock after setting the address to ensure the registered output (if any) is stable.

    ```verilog
    virtual_address = 4'd4;
    @(posedge clk);
    #1;
    #1;

    check_outputs(2'd1);
    ```

    One more check: "each testcases should begin with reset and end with output check."

    ```verilog
    task testcase001;
        begin
            test_num = test_num + 1;
            reset_dut();
            virtual_address = 4'h0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(2'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mmu Testbench");
        $display("========================================");


        testcase001();
        testcases1();
        
        
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
        input [1:0] expected_physical_address;
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
        $dumpvars(0,clk, reset, virtual_address, physical_address);
    end

endmodule
