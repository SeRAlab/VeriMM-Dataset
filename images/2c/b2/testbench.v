`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1;
    reg [31:0] data2;
    reg [4:0] dest1;
    reg [4:0] dest2;
    reg forward1;
    reg forward2;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [31:0] out1;
    wire [31:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .data1(data1),
        .data2(data2),
        .dest1(dest1),
        .dest2(dest2),
        .forward1(forward1),
        .forward2(forward2),
        .src1(src1),
        .src2(src2),
        .out1(out1),
        .out2(out2)
    );
    task initialize;

        begin
            data1 = 32'h0;
            data2 = 32'h0;
            dest1 = 5'd0;
            dest2 = 5'd0;
            forward1 = 1'b0;
            forward2 = 1'b0;
            src1 = 5'd0;
            src2 = 5'd0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state / No matches", test_num);
            initialize();
            src1 = 5'd1;
            src2 = 5'd2;
            dest1 = 5'd3;
            dest2 = 5'd4;
            forward1 = 1'b1;
            forward2 = 1'b1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Forwarding data1 to src1", test_num);
            initialize();
            data1 = 32'hAAAA_AAAA;
            src1 = 5'd10;
            dest1 = 5'd10;
            forward1 = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Forwarding data2 to src1", test_num);
            initialize();
            data2 = 32'hBBBB_BBBB;
            src1 = 5'd15;
            dest2 = 5'd15;
            forward2 = 1'b1;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Forwarding data1 to src2", test_num);
            initialize();
            data1 = 32'hCCCC_CCCC;
            src2 = 5'd20;
            dest1 = 5'd20;
            forward1 = 1'b1;
            #1;

            check_outputs(32'h0, 32'hCCCC_CCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Forwarding data2 to src2", test_num);
            initialize();
            data2 = 32'hDDDD_DDDD;
            src2 = 5'd25;
            dest2 = 5'd25;
            forward2 = 1'b1;
            #1;

            check_outputs(32'h0, 32'hDDDD_DDDD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Priority Check - src1 matches both dest1 and dest2", test_num);
            initialize();
            data1 = 32'h1111_1111;
            data2 = 32'h2222_2222;
            src1 = 5'd5;
            dest1 = 5'd5;
            dest2 = 5'd5;
            forward1 = 1'b1;
            forward2 = 1'b1;

            #1;


            check_outputs(32'h1111_1111, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Simultaneous forwarding to both sources", test_num);
            initialize();
            data1 = 32'hAAAA_1111;
            data2 = 32'hBBBB_2222;
            src1 = 5'd2;
            src2 = 5'd3;
            dest1 = 5'd2;
            dest2 = 5'd3;
            forward1 = 1'b1;
            forward2 = 1'b1;
            #1;

            check_outputs(32'hAAAA_1111, 32'hBBBB_2222);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Forwarding signal disabled (forward=0)", test_num);
            initialize();
            data1 = 32'hFFFF_FFFF;
            src1 = 5'd8;
            dest1 = 5'd8;
            forward1 = 1'b0;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Register $0 should not be forwarded", test_num);
            initialize();
            data1 = 32'hFFFF_FFFF;
            src1 = 5'd0;
            dest1 = 5'd0;
            forward1 = 1'b1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Complex routing (src1<-data2, src2<-data1)", test_num);
            initialize();
            data1 = 32'h1234_5678;
            data2 = 32'h8765_4321;
            src1 = 5'd30;
            src2 = 5'd31;
            dest1 = 5'd31;
            dest2 = 5'd30;
            forward1 = 1'b1;
            forward2 = 1'b1;
            #1;

            check_outputs(32'h8765_4321, 32'h1234_5678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
