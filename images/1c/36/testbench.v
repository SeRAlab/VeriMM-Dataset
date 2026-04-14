`timescale 1ns/1ps

module simple_hash_table_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] addr;
    reg [4:0] data_in;
    reg write_en;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_hash_table dut (
        .addr(addr),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write to Address 0 and Read Back", test_num);

            write_en = 1'b1;
            addr = 5'd0;
            data_in = 5'h1A;
            #10;
            write_en = 1'b0;
            #10;

            #1;


            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write to Address 1 and Read Back", test_num);

            write_en = 1'b1;
            addr = 5'd1;
            data_in = 5'h05;
            #10;
            write_en = 1'b0;
            #10;

            #1;


            check_outputs(5'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write to Address 2 and Read Back", test_num);

            write_en = 1'b1;
            addr = 5'd2;
            data_in = 5'h1F;
            #10;
            write_en = 1'b0;
            #10;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write to Address 3 and Read Back", test_num);

            write_en = 1'b1;
            addr = 5'd3;
            data_in = 5'h10;
            #10;
            write_en = 1'b0;
            #10;

            #1;


            check_outputs(5'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Test Hash Mapping (Address Collision)", test_num);


            write_en = 1'b1;
            addr = 5'd4;
            data_in = 5'h0E;
            #10;
            write_en = 1'b0;
            #10;

            addr = 5'd0;
            #10;
            #1;

            check_outputs(5'h0E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify write_en functionality", test_num);

            addr = 5'd1;
            #10;


            write_en = 1'b0;
            data_in = 5'h11;
            #10;


            #1;



            check_outputs(5'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite an existing entry", test_num);

            write_en = 1'b1;
            addr = 5'd2;
            data_in = 5'h07;
            #10;
            write_en = 1'b0;
            #10;
            #1;

            check_outputs(5'h07);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_hash_table Testbench");
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
        input [4:0] expected_data_out;
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
