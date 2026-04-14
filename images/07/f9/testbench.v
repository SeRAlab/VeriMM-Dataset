`timescale 1ns/1ps

module merge_sort_4way_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [31:0] sorted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4way dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sorted_output(sorted_output)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd10;
            b = 8'd20;
            c = 8'd30;
            d = 8'd40;
            $display("Test %0d: Already sorted ascending inputs", test_num);

            #1;


            check_outputs(32'h0A141E28);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd255;
            b = 8'd170;
            c = 8'd85;
            d = 8'd0;
            $display("Test %0d: Reverse sorted inputs (descending)", test_num);

            #1;


            check_outputs(32'h0055AAFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'd42;
            b = 8'd42;
            c = 8'd42;
            d = 8'd42;
            $display("Test %0d: All inputs identical", test_num);

            #1;


            check_outputs(32'h2A2A2A2A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd128;
            b = 8'd10;
            c = 8'd128;
            d = 8'd10;
            $display("Test %0d: Two pairs of identical values", test_num);

            #1;


            check_outputs(32'h0A0A8080);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'hFF;
            b = 8'h01;
            c = 8'hFE;
            d = 8'h00;
            $display("Test %0d: Minimum and maximum boundary values", test_num);

            #1;


            check_outputs(32'h0001FEFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'd75;
            b = 8'd12;
            c = 8'd200;
            d = 8'd48;
            $display("Test %0d: Random permutation", test_num);


            #1;



            check_outputs(32'h0C304BC8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4way Testbench");
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
        input [31:0] expected_sorted_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted_output === (expected_sorted_output ^ sorted_output ^ expected_sorted_output)) begin
                $display("PASS");
                $display("  Outputs: sorted_output=%h",
                         sorted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted_output=%h",
                         expected_sorted_output);
                $display("  Got:      sorted_output=%h",
                         sorted_output);
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
