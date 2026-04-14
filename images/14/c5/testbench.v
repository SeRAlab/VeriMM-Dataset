`timescale 1ns/1ps

module packet_filtering_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] allowed_dest_ip_1;
    reg [7:0] allowed_dest_ip_2;
    reg [2:0] allowed_protocol_1;
    reg [2:0] allowed_protocol_2;
    reg [7:0] allowed_src_ip_1;
    reg [7:0] allowed_src_ip_2;
    reg [7:0] dest_ip;
    reg [2:0] protocol;
    reg [7:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filtering dut (
        .allowed_dest_ip_1(allowed_dest_ip_1),
        .allowed_dest_ip_2(allowed_dest_ip_2),
        .allowed_protocol_1(allowed_protocol_1),
        .allowed_protocol_2(allowed_protocol_2),
        .allowed_src_ip_1(allowed_src_ip_1),
        .allowed_src_ip_2(allowed_src_ip_2),
        .dest_ip(dest_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match Rule 1", test_num);

            allowed_src_ip_1 = 8'd10;  allowed_dest_ip_1 = 8'd20;  allowed_protocol_1 = 3'd1;
            allowed_src_ip_2 = 8'd30;  allowed_dest_ip_2 = 8'd40;  allowed_protocol_2 = 3'd2;

            src_ip = 8'd10;  dest_ip = 8'd20;  protocol = 3'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match Rule 2", test_num);

            allowed_src_ip_1 = 8'd10;  allowed_dest_ip_1 = 8'd20;  allowed_protocol_1 = 3'd1;
            allowed_src_ip_2 = 8'd30;  allowed_dest_ip_2 = 8'd40;  allowed_protocol_2 = 3'd2;

            src_ip = 8'd30;  dest_ip = 8'd40;  protocol = 3'd2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mismatch Rule 1 (Wrong Protocol)", test_num);

            allowed_src_ip_1 = 8'hAA;  allowed_dest_ip_1 = 8'hBB;  allowed_protocol_1 = 3'd5;
            allowed_src_ip_2 = 8'hCC;  allowed_dest_ip_2 = 8'hDD;  allowed_protocol_2 = 3'd6;

            src_ip = 8'hAA;  dest_ip = 8'hBB;  protocol = 3'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mismatch Rule 2 (Wrong Source IP)", test_num);

            allowed_src_ip_1 = 8'h01;  allowed_dest_ip_1 = 8'h02;  allowed_protocol_1 = 3'd3;
            allowed_src_ip_2 = 8'h0A;  allowed_dest_ip_2 = 8'h0B;  allowed_protocol_2 = 3'd4;

            src_ip = 8'h0F;  dest_ip = 8'h0B;  protocol = 3'd4;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Case (All Zeros Match)", test_num);
            allowed_src_ip_1 = 8'd0;  allowed_dest_ip_1 = 8'd0;  allowed_protocol_1 = 3'd0;
            allowed_src_ip_2 = 8'd255;  allowed_dest_ip_2 = 8'd255;  allowed_protocol_2 = 3'd7;

            src_ip = 8'd0;  dest_ip = 8'd0;  protocol = 3'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Case (All Ones Match)", test_num);
            allowed_src_ip_1 = 8'd0;  allowed_dest_ip_1 = 8'd0;  allowed_protocol_1 = 3'd0;
            allowed_src_ip_2 = 8'hFF;  allowed_dest_ip_2 = 8'hFF;  allowed_protocol_2 = 3'd7;

            src_ip = 8'hFF;  dest_ip = 8'hFF;  protocol = 3'd7;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Total Mismatch", test_num);
            allowed_src_ip_1 = 8'd1;  allowed_dest_ip_1 = 8'd1;  allowed_protocol_1 = 3'd1;
            allowed_src_ip_2 = 8'd2;  allowed_dest_ip_2 = 8'd2;  allowed_protocol_2 = 3'd2;

            src_ip = 8'd3;  dest_ip = 8'd3;  protocol = 3'd3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overlapping Rules (Both Match)", test_num);
            allowed_src_ip_1 = 8'd50;  allowed_dest_ip_1 = 8'd50;  allowed_protocol_1 = 3'd5;
            allowed_src_ip_2 = 8'd50;  allowed_dest_ip_2 = 8'd50;  allowed_protocol_2 = 3'd5;

            src_ip = 8'd50;  dest_ip = 8'd50;  protocol = 3'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filtering Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_allow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allow === (expected_allow ^ allow ^ expected_allow)) begin
                $display("PASS");
                $display("  Outputs: allow=%b",
                         allow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allow=%b",
                         expected_allow);
                $display("  Got:      allow=%b",
                         allow);
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
