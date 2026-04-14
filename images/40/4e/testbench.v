`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] access_type;
    reg clk;
    reg [7:0] logical_address;
    reg reset;
    wire [7:0] physical_address;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .access_type(access_type),
        .clk(clk),
        .logical_address(logical_address),
        .reset(reset),
        .physical_address(physical_address),
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
            access_type = 2'b00;
            logical_address = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid Read Operation (Logical 0x05)", test_num);
            reset_dut();

            access_type = 2'b01;
            logical_address = 8'h05;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid Write Operation (Logical 0x1A)", test_num);
            reset_dut();

            access_type = 2'b10;
            logical_address = 8'h1A;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h1A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Page Fault (Logical 0xFF)", test_num);
            reset_dut();

            access_type = 2'b01;
            logical_address = 8'hFF;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle Mode (No Access)", test_num);
            reset_dut();

            access_type = 2'b00;
            logical_address = 8'h10;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Read (Logical 0x00)", test_num);
            reset_dut();

            access_type = 2'b01;
            logical_address = 8'h00;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_physical_address;
        input expected_status;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h, status=%b",
                         physical_address, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h, status=%b",
                         expected_physical_address, expected_status);
                $display("  Got:      physical_address=%h, status=%b",
                         physical_address, status);
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
        $dumpvars(0,access_type, clk, logical_address, reset, physical_address, status);
    end

endmodule
