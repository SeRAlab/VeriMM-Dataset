`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] logical_address;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
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
            logical_address <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Page 0, Offset 0");
            reset_dut();
            logical_address = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Page 1, Offset 5");
            reset_dut();
            logical_address = 8'h15;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h25);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Page 2, Offset A");
            reset_dut();
            logical_address = 8'h2A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h4A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Page 3, Offset F");
            reset_dut();
            logical_address = 8'h3F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h8F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Page 4, Offset 0");
            reset_dut();
            logical_address = 8'h40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Page 15, Offset E");
            reset_dut();
            logical_address = 8'hFE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
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
        input [7:0] expected_physical_address;
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
        $dumpvars(0,clk, logical_address, physical_address);
    end

endmodule
