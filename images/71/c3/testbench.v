`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg shift_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_in(shift_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Synchronous Reset", test_num);

        rst = 1;
        load = 0;
        data_in = 8'hFF;
        shift_in = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00);
        rst = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load", test_num);

        rst = 1; @(posedge clk); #1; rst = 0;


        data_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Shift Left", test_num);

        rst = 1; @(posedge clk); #1; rst = 0;


        data_in = 8'h01;
        load = 1;
        @(posedge clk);
        #1;


        load = 0;
        shift_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Fill Register via 8 Shifts", test_num);

        rst = 1; @(posedge clk); #1; rst = 0;

        load = 0;

        shift_in = 1; @(posedge clk); #1;
        shift_in = 0; @(posedge clk); #1;
        shift_in = 1; @(posedge clk); #1;
        shift_in = 1; @(posedge clk); #1;
        shift_in = 0; @(posedge clk); #1;
        shift_in = 0; @(posedge clk); #1;
        shift_in = 1; @(posedge clk); #1;
        shift_in = 1; @(posedge clk); #1;

        #1;


        check_outputs(8'hB3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load Priority Over Shift", test_num);

        rst = 1; @(posedge clk); #1; rst = 0;


        data_in = 8'h3C;
        load = 1;
        shift_in = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'h3C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift High Bit and Shift In 1", test_num);

        rst = 1; @(posedge clk); #1; rst = 0;


        data_in = 8'h80;
        load = 1;
        @(posedge clk);
        #1;



        load = 0;
        shift_in = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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

endmodule
