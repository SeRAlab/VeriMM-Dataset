`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] virtual_addr;
    wire page_fault;
    wire [7:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .clk(clk),
        .rst(rst),
        .virtual_addr(virtual_addr),
        .page_fault(page_fault),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            virtual_addr = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            virtual_addr = 8'h05;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            virtual_addr = 8'h1A;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h2A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            virtual_addr = 8'hF0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            virtual_addr = 8'h00;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            virtual_addr = 8'h12;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h22);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MMU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_page_fault;
        input [7:0] expected_physical_addr;
        begin
            if (expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: page_fault=%b, physical_addr=%h",
                         page_fault, physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_fault=%b, physical_addr=%h",
                         expected_page_fault, expected_physical_addr);
                $display("  Got:      page_fault=%b, physical_addr=%h",
                         page_fault, physical_addr);
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
        $dumpvars(0,clk, rst, virtual_addr, page_fault, physical_addr);
    end

endmodule
