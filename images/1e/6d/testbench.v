`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data1;
    reg [4:0] data2;
    reg sel;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .data1(data1),
        .data2(data2),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forwarding data1 (5'h1A) when sel is 0", test_num);
            data1 = 5'h1A;
            data2 = 5'h05;
            sel = 1'b0;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forwarding data2 (5'h05) when sel is 1", test_num);
            data1 = 5'h1A;
            data2 = 5'h05;
            sel = 1'b1;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones on data1, All zeros on data2, sel is 0", test_num);
            data1 = 5'h1F;
            data2 = 5'h00;
            sel = 1'b0;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones on data1, All zeros on data2, sel is 1", test_num);
            data1 = 5'h1F;
            data2 = 5'h00;
            sel = 1'b1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern, sel is 0", test_num);
            data1 = 5'b10101;
            data2 = 5'b01010;
            sel = 1'b0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern, sel is 1", test_num);
            data1 = 5'b10101;
            data2 = 5'b01010;
            sel = 1'b1;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding Testbench");
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
        input [4:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
