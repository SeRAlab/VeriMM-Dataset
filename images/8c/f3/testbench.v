`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 4'h0;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 4'h1;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 4'h2;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 4'h3;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 4'h4;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 4'h5;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 4'h6;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 4'h7;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 4'h8;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 4'h9;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0200);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            data_in = 4'hA;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            data_in = 4'hB;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            data_in = 4'hC;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            data_in = 4'hD;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            data_in = 4'hE;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            data_in = 4'hF;
            $display("Test Case %0d: Input = %h", test_num, data_in);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [15:0] expected_data_out;
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
