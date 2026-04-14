`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] virtual_addr;
    wire [2:0] physical_addr;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .clk(clk),
        .reset(reset),
        .virtual_addr(virtual_addr),
        .physical_addr(physical_addr),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            virtual_addr = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid Mapping - VA 00000 (Page 0, Offset 0)", test_num);
            reset_dut();
            virtual_addr = 5'b000_00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid Mapping - VA 00111 (Page 1, Offset 3)", test_num);
            reset_dut();
            virtual_addr = 5'b001_11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid Mapping - VA 01000 (Page 2, Offset 0)", test_num);
            reset_dut();
            virtual_addr = 5'b010_00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid Mapping - VA 11111 (Page 7, Offset 3)", test_num);
            reset_dut();
            virtual_addr = 5'b111_11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: System state during Reset", test_num);
            reset = 1;
            virtual_addr = 5'b00000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b000, 1'b0);
            reset = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive access (Page 0 then Page 1)", test_num);
            reset_dut();


            virtual_addr = 5'b000_10;
            @(posedge clk);
            #2;


            virtual_addr = 5'b001_01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b101, 1'b1);
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
        input [2:0] expected_physical_addr;
        input expected_valid;
        begin
            if (expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: physical_addr=%h, valid=%b",
                         physical_addr, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_addr=%h, valid=%b",
                         expected_physical_addr, expected_valid);
                $display("  Got:      physical_addr=%h, valid=%b",
                         physical_addr, valid);
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
        $dumpvars(0,clk, reset, virtual_addr, physical_addr, valid);
    end

endmodule
