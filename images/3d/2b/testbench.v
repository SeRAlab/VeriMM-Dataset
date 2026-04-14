`timescale 1ns/1ps

module virtual_memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] logical_address;
    reg [1:0] operation;
    reg reset;
    wire [3:0] physical_address;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_manager dut (
        .clk(clk),
        .logical_address(logical_address),
        .operation(operation),
        .reset(reset),
        .physical_address(physical_address),
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
            logical_address = 0;
            operation = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial state after reset (Logical Address 0)", test_num);
            reset_dut();

            logical_address = 4'h0;
            operation = 2'b10;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Map Logical 5 and Read Back", test_num);
            reset_dut();


            logical_address = 4'h5;
            operation = 2'b01;
            @(posedge clk);


            operation = 2'b10;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify unmapped address (Logical 10) remains invalid", test_num);
            reset_dut();


            logical_address = 4'h2;
            operation = 2'b01;
            @(posedge clk);


            logical_address = 4'hA;
            operation = 2'b10;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Map and Read Boundary Address 15", test_num);
            reset_dut();


            logical_address = 4'hF;
            operation = 2'b01;
            @(posedge clk);


            operation = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple entries (Map 3, Map 8, Read 3)", test_num);
            reset_dut();


            logical_address = 4'h3;
            operation = 2'b01;
            @(posedge clk);


            logical_address = 4'h8;
            operation = 2'b01;
            @(posedge clk);


            logical_address = 4'h3;
            operation = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h3, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_manager Testbench");
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
        input [3:0] expected_physical_address;
        input expected_valid;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h, valid=%b",
                         physical_address, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h, valid=%b",
                         expected_physical_address, expected_valid);
                $display("  Got:      physical_address=%h, valid=%b",
                         physical_address, valid);
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
        $dumpvars(0,clk, logical_address, operation, reset, physical_address, valid);
    end

endmodule
