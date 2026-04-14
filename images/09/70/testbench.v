`timescale 1ns/1ps

module des_round_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [63:0] data_in;
    reg [55:0] key;
    reg rst;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_round dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .rst(rst),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros", test_num);


            rst = 1;
            data_in = 64'h0;
            key = 56'h0;
            @(posedge clk);
            #1 rst = 0;


            @(posedge clk);



            #1;




            check_outputs(64'h00000000EFA72C4D);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Ones", test_num);

            rst = 1;
            data_in = 64'hFFFFFFFFFFFFFFFF;
            key = 56'hFFFFFFFFFFFFFF;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);


            #1;



            check_outputs(64'hFFFFFFFF7C312E92);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Standard Hex Sequence", test_num);

            rst = 1;
            data_in = 64'h0123456789ABCDEF;
            key = 56'h133457799BBCDF;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);



            #1;




            check_outputs(64'h89ABCDEF221E57F8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Alternating Bits", test_num);

            rst = 1;
            data_in = 64'h5555555555555555;
            key = 56'h2AAAAAAAAAAAAA;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);

            #1;


            check_outputs(64'h555555552309B7A3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [63:0] expected_data_out;
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
