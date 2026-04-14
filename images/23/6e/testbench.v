`timescale 1ns/1ps

module VirtualMemoryUnit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] virtual_addr;
    wire [9:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryUnit dut (
        .clk(clk),
        .virtual_addr(virtual_addr),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            virtual_addr = 20'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: All Zeros", test_num);
            virtual_addr = 20'h00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: All Ones", test_num);
            virtual_addr = 20'hFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Lower Bits Set, Upper Zero", test_num);
            virtual_addr = 20'h003FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Random Address A", test_num);


            virtual_addr = 20'hABCDE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h2AF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Random Address B", test_num);


            virtual_addr = 20'h55555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h155);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Bit 10 Boundary Check", test_num);


            virtual_addr = 20'h00400;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Sequential Logic Verification", test_num);

            virtual_addr = 20'h12345;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h048);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryUnit Testbench");
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
        input [9:0] expected_physical_addr;
        begin
            if (expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: physical_addr=%h",
                         physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_addr=%h",
                         expected_physical_addr);
                $display("  Got:      physical_addr=%h",
                         physical_addr);
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
        $dumpvars(0,clk, virtual_addr, physical_addr);
    end

endmodule
