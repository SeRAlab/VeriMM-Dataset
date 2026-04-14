`timescale 1ns/1ps

module VirtualMemoryManagementUnit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] logical_address;
    reg read_enable;
    reg reset;
    wire [11:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagementUnit dut (
        .clk(clk),
        .logical_address(logical_address),
        .read_enable(read_enable),
        .reset(reset),
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
            logical_address = 12'h0;
            read_enable = 1'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Low Address Translation", test_num);
            reset_dut();
            logical_address = 12'h055;
            read_enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h055);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Mid Address Translation", test_num);
            reset_dut();
            logical_address = 12'h7AB;
            read_enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h7AB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: High Address Translation", test_num);
            reset_dut();
            logical_address = 12'hF01;
            read_enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hF01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Read Enable Disabled", test_num);
            reset_dut();
            logical_address = 12'hABC;
            read_enable = 1'b0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Consecutive Access", test_num);
            reset_dut();


            logical_address = 12'h123;
            read_enable = 1'b1;
            @(posedge clk);
            #2;


            logical_address = 12'h456;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h456);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManagementUnit Testbench");
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
        input [11:0] expected_physical_address;
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
        $dumpvars(0,clk, logical_address, read_enable, reset, physical_address);
    end

endmodule
